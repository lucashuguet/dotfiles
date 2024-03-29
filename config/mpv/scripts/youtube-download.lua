-- youtube-download.lua
--
-- Download video/audio from youtube via yt-dlp and ffmpeg/avconv
-- This is forked/based on https://github.com/jgreco/mpv-youtube-quality
--
-- Video download bound to ctrl-d by default.
-- Audio download bound to ctrl-a by default.

-- Requires yt-dlp in PATH for video download
-- Requires ffmpeg or avconv in PATH for audio download

local mp = require 'mp'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

local opts = {
    -- Key bindings
    -- Set to empty string "" to disable
    download_video_binding = "ctrl+d",
    download_audio_binding = "ctrl+a",
    download_subtitle_binding = "ctrl+s",
    download_video_embed_subtitle_binding = "ctrl+i",
    select_range_binding = "ctrl+r",

    -- Specify audio format: "best", "aac","flac", "mp3", "m4a", "opus", "vorbis", or "wav"
    audio_format = "mp3",

    -- Specify ffmpeg/avconv audio quality
    -- insert a value between 0 (better) and 9 (worse) for VBR or a specific bitrate like 128K
    audio_quality = "0",

    -- Same as yt-dlp --format FORMAT
    -- see https://github.com/ytdl-org/yt-dlp/blob/master/README.md#format-selection
    -- set to "current" to download the same quality that is currently playing
    video_format = "",

    -- Encode the video to another format if necessary: "mp4", "flv", "ogg", "webm", "mkv", "avi"
    recode_video = "",

    -- Restrict filenames to only ASCII characters, and avoid "&" and spaces in filenames
    restrict_filenames = true,

    -- Download the whole playlist (false) or only one video (true)
    -- Same as yt-dlp --no-playlist
    no_playlist = true,

    -- Use an archive file, see yt-dlp --download-archive
    -- You have these options:
    --  * Set to empty string "" to not use an archive file
    --  * Set an absolute path to use one archive for all downloads e.g. download_archive="/home/user/archive.txt"
    --  * Set a relative path/only a filename to use one archive per directory e.g. download_archive="archive.txt"
    --  * Use $PLAYLIST to create one archive per playlist e.g. download_archive="/home/user/archives/$PLAYLIST.txt"
    download_archive = "",

    -- Use a cookies file for yt-dlp
    -- Same as yt-dlp --cookies
    -- On Windows you need to use a double blackslash or a single fordwardslash
    -- For example "C:\\Users\\Username\\cookies.txt"
    -- Or "C:/Users/Username/cookies.txt"
    cookies = "",

    -- Filename or full path
    -- Same as yt-dlp -o FILETEMPLATE
    -- see https://github.com/ytdl-org/yt-dlp/blob/master/README.md#output-template
    -- A relative path or a file name is relative to the path mpv was launched from
    -- On Windows you need to use a double blackslash or a single fordwardslash
    -- For example "C:\\Users\\Username\\Downloads\\%(title)s.%(ext)s"
    -- Or "C:/Users/Username/Downloads/%(title)s.%(ext)s"
    filename = "%(title)s.%(ext)s",

    -- Subtitle language
    -- Same as yt-dlp --sub-lang en
    sub_lang = "en",

    -- Subtitle format
    -- Same as yt-dlp --sub-format best
    sub_format = "best",

    -- Log file for download errors
    log_file = "",

}

--Read configuration file
(require 'mp.options').read_options(opts, "youtube-download")

--Read command line arguments
local ytdl_raw_options = mp.get_property("ytdl-raw-options")
if ytdl_raw_options ~= nil and ytdl_raw_options:find("cookies=") ~= nil then
    local cookie_file = ytdl_raw_options:match("cookies=([^,]+)")
    if cookie_file ~= nil then
        opts.cookies = cookie_file
    end
end

local function exec(args, capture_stdout, capture_stderr)
    local ret = mp.command_native({
        name = "subprocess",
        playback_only = false,
        capture_stdout = capture_stdout,
        capture_stderr = capture_stderr,
        args = args,
    })
    return ret.status, ret.stdout, ret.stderr, ret
end

local function trim(str)
    return str:gsub("^%s+", ""):gsub("%s+$", "")
end

local function not_empty(str)
    if str == nil or str == "" then
        return false
    end
    return trim(str) ~= ""
end

local function path_separator()
    return package.config:sub(1,1)
end

local function path_join(...)
    return table.concat({...}, path_separator())
end

local function get_current_format()
    -- get the current yt-dlp format or the default value
    local ytdl_format = mp.get_property("options/ytdl-format")
    if not_empty(ytdl_format) then
        return  ytdl_format
    end
    ytdl_format = mp.get_property("ytdl-format")
    if not_empty(ytdl_format) then
        return ytdl_format
    end
    return "bestvideo+bestaudio/best"
end

local DOWNLOAD = {
    VIDEO=1,
    AUDIO=2,
    SUBTITLE=3,
    VIDEO_EMBED_SUBTITLE=4
}
local select_range_mode = 0
local start_time_seconds = nil
local start_time_formated = nil
local end_time_seconds = nil
local end_time_formated = nil

local is_downloading = false

local function disable_select_range()
    -- Disable range mode
    select_range_mode = 0
    -- Remove the arrow key key bindings
    mp.remove_key_binding("select-range-set-up")
    mp.remove_key_binding("select-range-set-down")
    mp.remove_key_binding("select-range-set-left")
    mp.remove_key_binding("select-range-set-right")
end


local function download(download_type)
    local start_time = os.date("%c")
    if is_downloading then
        return
    end
    is_downloading = true

    local ass0 = mp.get_property("osd-ass-cc/0")
    local ass1 =  mp.get_property("osd-ass-cc/1")
    local url = mp.get_property("path")

    url = string.gsub(url, "ytdl://", "") -- Strip possible ytdl:// prefix.

    if string.find(url, "//youtu.be/") == nil
    and string.find(url, "//ww.youtu.be/") == nil
    and string.find(url, "//youtube.com/") == nil
    and string.find(url, "//www.youtube.com/") == nil
    then
        mp.osd_message("Not a youtube URL: " .. tostring(url), 10)
        is_downloading = false
        return
    end

    local list_match = url:match("list=(%w+)")
    local download_archive = opts.download_archive
    if list_match ~= nil and opts.download_archive ~= nil and opts.download_archive:find("$PLAYLIST", 1, true) then
        download_archive = opts.download_archive:gsub("$PLAYLIST", list_match)
    end

    if download_type == DOWNLOAD.AUDIO then
        mp.osd_message("Audio download started", 2)
    elseif download_type == DOWNLOAD.SUBTITLE then
        mp.osd_message("Subtitle download started", 2)
    elseif download_type == DOWNLOAD.VIDEO_EMBED_SUBTITLE then
        mp.osd_message("Video w/ subtitle download started", 2)
    else
        mp.osd_message("Video download started", 2)
    end

    -- Compose command line arguments
    local command = {}

    local range_mode_file_name = nil
    local range_mode_subtitle_file_name = nil
    local start_time_offset = 0

    if select_range_mode == 0 or (select_range_mode > 0 and (download_type == DOWNLOAD.AUDIO or download_type == DOWNLOAD.SUBTITLE)) then
        table.insert(command, "yt-dlp")
        table.insert(command, "--no-overwrites")
        if opts.restrict_filenames then
          table.insert(command, "--restrict-filenames")
        end
        if not_empty(opts.filename) then
            table.insert(command, "-o")
            table.insert(command, opts.filename)
        end
        if opts.no_playlist then
            table.insert(command, "--no-playlist")
        end
        if not_empty(download_archive) then
            table.insert(command, "--download-archive")
            table.insert(command, download_archive)
        end

        if download_type == DOWNLOAD.SUBTITLE then
            table.insert(command, "--sub-lang")
            table.insert(command, opts.sub_lang)
            table.insert(command, "--write-sub")
            table.insert(command, "--skip-download")
            if not_empty(opts.sub_format) then
                table.insert(command, "--sub-format")
                table.insert(command, opts.sub_format)
            end
            if select_range_mode > 0 then
                mp.osd_message("Range mode is not available for subtitle-only download", 10)
                is_downloading = false
                return
            end
        elseif download_type == DOWNLOAD.AUDIO then
            table.insert(command, "--extract-audio")
            if not_empty(opts.audio_format) then
              table.insert(command, "--audio-format")
              table.insert(command, opts.audio_format)
            end
            if not_empty(opts.audio_quality) then
              table.insert(command, "--audio-quality")
              table.insert(command, opts.audio_quality)
            end
            if  select_range_mode > 0 then
                local start_time_str = tostring(start_time_seconds)
                local end_time_str = tostring(end_time_seconds)
                table.insert(command, "--external-downloader")
                table.insert(command, "ffmpeg")
                table.insert(command, "--external-downloader-args")
                table.insert(command, "-loglevel warning -nostats -hide_banner -ss ".. start_time_str .. " -to " .. end_time_str .. " -avoid_negative_ts make_zero")
            end
        else --DOWNLOAD.VIDEO or DOWNLOAD.VIDEO_EMBED_SUBTITLE
            if download_type == DOWNLOAD.VIDEO_EMBED_SUBTITLE then
                table.insert(command, "--all-subs")
                table.insert(command, "--write-sub")
                table.insert(command, "--embed-subs")
                if not_empty(opts.sub_format) then
                    table.insert(command, "--sub-format")
                    table.insert(command, opts.sub_format)
                end
            end
            if not_empty(opts.video_format) then
              table.insert(command, "--format")
              if opts.video_format == "current" then
                table.insert(command, get_current_format())
              else
                table.insert(command, opts.video_format)
              end
            end
            if not_empty(opts.recode_video) then
              table.insert(command, "--recode-video")
              table.insert(command, opts.recode_video)
            end
        end
        if not_empty(opts.cookies) then
            table.insert(command, "--cookies")
            table.insert(command, opts.cookies)
        end
        table.insert(command, url)

    elseif select_range_mode > 0 and
        (download_type == DOWNLOAD.VIDEO or download_type == DOWNLOAD.VIDEO_EMBED_SUBTITLE) then

        -- Show download indicator
        mp.set_osd_ass(0, 0, "{\\an9}{\\fs12}⌛🔗")

        start_time_seconds = math.floor(start_time_seconds)
        end_time_seconds = math.ceil(end_time_seconds)

        local start_time_str = tostring(start_time_seconds)
        local end_time_str = tostring(end_time_seconds)

        -- Add time to the file name of the video
        local filename_format
        -- Insert start time/end time
        if not_empty(opts.filename) then
            if opts.filename:find("%%%(start_time%)") ~= nil then
                -- Found "start_time" -> replace it
                filename_format = tostring(opts.filename:
                    gsub("%%%(start_time%)[^diouxXeEfFgGcrs]*[diouxXeEfFgGcrs]", start_time_str):
                    gsub("%%%(end_time%)[^diouxXeEfFgGcrs]*[diouxXeEfFgGcrs]", end_time_str))
            else
                local ext_pattern = "%(ext)s"
                if opts.filename:sub(-#ext_pattern) == ext_pattern then
                    -- Insert before ext
                    filename_format = opts.filename:sub(1, #(opts.filename) - #ext_pattern) ..
                        start_time_str .. "-" ..
                        end_time_str .. ".%(ext)s"
                else
                    -- append at end
                    filename_format = opts.filename .. start_time_str .. "-" .. end_time_str
                end
            end
        else
            -- default yt-dlp filename pattern
            filename_format = "%(title)s-%(id)s." .. start_time_str .. "-" .. end_time_str .. ".%(ext)s"
        end

        -- Find a suitable format
        local format = "bestvideo[ext*=mp4]+bestaudio/best[ext*=mp4]/best"
        local requested_format = opts.video_format
        if requested_format == "current" then
            requested_format = get_current_format()
        end
        if requested_format == nil or requested_format == "" then
            format = format
        elseif requested_format == "best" then
            -- "best" works, because its a single file stream
            format = "best"
        elseif requested_format:find("mp4") ~= nil then
            -- probably a mp4 format, so use it
            format = requested_format
        else
            -- custom format, no "mp4" found -> use default
            msg.warn("Select range mode requires a .mp4 format or \"best\", found "  ..
            requested_format .. "\n(" .. opts.video_format .. ")" ..
                    "\nUsing default format instead: " .. format)
        end

        -- Get the download url of the video file
        -- e.g.: yt-dlp -g -f bestvideo[ext*=mp4]+bestaudio/best[ext*=mp4]/best -s --get-filename https://www.youtube.com/watch?v=abcdefg
        command = {"yt-dlp"}
        if opts.restrict_filenames then
            table.insert(command, "--restrict-filenames")
        end
        if not_empty(opts.cookies) then
            table.insert(command, "--cookies")
            table.insert(command, opts.cookies)
        end
        table.insert(command, "-g")
        table.insert(command, "--no-playlist")
        table.insert(command, "-f")
        table.insert(command, format)
        table.insert(command, "-o")
        table.insert(command, filename_format)
        table.insert(command, "-s")
        table.insert(command, "--get-filename")
        table.insert(command, url)

        msg.debug("info exec: " .. table.concat(command, " "))
        local info_status, info_stdout, info_stderr = exec(command, true, true)
        if info_status ~= 0 then
            mp.set_osd_ass(0, 0, "")
            mp.osd_message("Could not retieve download stream url: status=" .. tostring(info_status) .. "\n" ..
                ass0 .. "{\\fs8} " .. info_stdout:gsub("\r", "") .."\n" .. info_stderr:gsub("\r", "") .. ass1, 20)
            msg.debug("info_stdout:\n" .. info_stdout)
            msg.debug("info_stderr:\n" .. info_stderr)
            mp.set_osd_ass(0, 0, "")
            is_downloading = false
            return
        end

        -- Split result into lines
        local info_lines = {}
        local last_index = 0
        local info_lines_N = 0
        while true do
            local start_i, end_i = info_stdout:find("\n", last_index, true)
            if start_i then
                local line = tostring(trim(info_stdout:sub(last_index, start_i)))
                if line ~= "" then
                    table.insert(info_lines, line)
                    info_lines_N = info_lines_N + 1
                end
            else
                break
            end
            last_index = end_i + 1
        end

        if info_lines_N < 2 then
            mp.set_osd_ass(0, 0, "")
            mp.osd_message("Could not extract download stream urls and filename from output\n" ..
                ass0 .. "{\\fs8} " .. info_stdout:gsub("\r", "") .."\n" .. info_stderr:gsub("\r", "") .. ass1, 20)
            msg.debug("info_stdout:\n" .. info_stdout)
            msg.debug("info_stderr:\n" .. info_stderr)
            mp.set_osd_ass(0, 0, "")
            is_downloading = false
            return
        end
        range_mode_file_name = info_lines[info_lines_N]
        table.remove(info_lines)

        if download_type == DOWNLOAD.VIDEO_EMBED_SUBTITLE then
            -- yt-dlp --write-sub --skip-download  https://www.youtube.com/watch?v=abcdefg -o "temp.%(ext)s"
            command = {"yt-dlp", "--write-sub", "--skip-download", "--sub-lang", opts.sub_lang}
            if not_empty(opts.sub_format) then
                table.insert(command, "--sub-format")
                table.insert(command, opts.sub_format)
            end
            local randomName = "tmp_" .. tostring(math.random())
            table.insert(command, "-o")
            table.insert(command, randomName .. ".%(ext)s")
            table.insert(command, url)

            -- Start subtitle download
            msg.debug("exec: " .. table.concat(command, " "))
            local subtitle_status, subtitle_stdout, subtitle_stderr = exec(command, true, true)
            if subtitle_status == 0 and subtitle_stdout:find(randomName) then
                local i, j = subtitle_stdout:find(randomName .. "[^\n]+")
                range_mode_subtitle_file_name = trim(subtitle_stdout:sub(i, j))
                if range_mode_subtitle_file_name ~= "" then
                    if range_mode_file_name:sub(-4) ~= ".mkv" then
                        -- Only mkv supports all kinds of subtitle formats
                        range_mode_file_name = range_mode_file_name:sub(1,-4) .. "mkv"
                    end
                end
            else
                mp.osd_message("Could not find a suitable subtitle")
                msg.debug("subtitle_stdout:\n" .. subtitle_stdout)
                msg.debug("subtitle_stderr:\n" .. subtitle_stderr)
            end

        end

        -- Download earlier (cut off afterwards)
        start_time_offset = math.min(15, start_time_seconds)
        start_time_seconds = start_time_seconds - start_time_offset

        start_time_str = tostring(start_time_seconds)
        end_time_str = tostring(end_time_seconds)

        command = {"ffmpeg", "-loglevel", "warning", "-nostats", "-hide_banner", "-y"}
        for _, value in ipairs(info_lines) do
            table.insert(command, "-ss")
            table.insert(command, start_time_str)
            table.insert(command, "-to")
            table.insert(command, end_time_str)
            table.insert(command, "-i")
            table.insert(command, value)
        end
        if not_empty(range_mode_subtitle_file_name) then
            table.insert(command, "-ss")
            table.insert(command, start_time_str)
            table.insert(command, "-i")
            table.insert(command, range_mode_subtitle_file_name)
            table.insert(command, "-to") -- To must be after input for subtitle
            table.insert(command, end_time_str)
        end
        table.insert(command, "-c")
        table.insert(command, "copy")
        table.insert(command, range_mode_file_name)

        disable_select_range()
    end

    -- Show download indicator
    mp.set_osd_ass(0, 0, "{\\an9}{\\fs12}⌛💾")

    -- Start download
    msg.debug("exec: " .. table.concat(command, " "))
    local status, stdout, stderr = exec(command, true, true)

    if status == 0 and range_mode_file_name ~= nil then
        mp.set_osd_ass(0, 0, "{\\an9}{\\fs12}⌛🔨")

        -- Cut first few seconds to fix errors
        local start_time_offset_str = tostring(start_time_offset)
        if #start_time_offset_str == 1 then
            start_time_offset_str = "0" .. start_time_offset_str
        end
        local max_length = end_time_seconds - start_time_seconds + start_time_offset + 12
        local tmp_file_name = range_mode_file_name .. ".tmp." .. range_mode_file_name:sub(-3)
        command = {"ffmpeg", "-loglevel", "warning", "-nostats", "-hide_banner", "-y",
            "-i", range_mode_file_name, "-ss", "00:00:" .. start_time_offset_str,
            "-c", "copy", "-avoid_negative_ts", "make_zero", "-t", tostring(max_length), tmp_file_name}
        msg.debug("mux exec: " .. table.concat(command, " "))
        local muxstatus, muxstdout, muxstderr = exec(command, true, true)
        if muxstatus ~= 0 and not_empty(muxstderr) then
            msg.warn("Remux log:" .. tostring(muxstdout))
            msg.warn("Remux errorlog:" .. tostring(muxstderr))
        end
        if muxstatus == 0 then
            os.remove(range_mode_file_name)
            os.rename(tmp_file_name, range_mode_file_name)
            if not_empty(range_mode_subtitle_file_name) then
                os.remove(range_mode_subtitle_file_name)
            end
        end

    end


    is_downloading = false

    -- Hide download indicator
    mp.set_osd_ass(0, 0, "")

    local wrote_error_log = false
    if stderr ~= nil and not_empty(opts.log_file) and not_empty(stderr) then
        -- Write stderr to log file
        local title = mp.get_property("media-title")
        local file = io.open (opts.log_file , "a+")
        file:write("\n[")
        file:write(start_time)
        file:write("] ")
        file:write(url)
        file:write("\n[\"")
        file:write(title)
        file:write("\"]\n")
        file:write(stderr)
        file:close()
        wrote_error_log = true
    end

    if (status ~= 0) then
        mp.osd_message("download failed:\n" .. tostring(stderr), 10)
        msg.error("URL: " .. tostring(url))
        msg.error("Return status code: " .. tostring(status))
        msg.debug(tostring(stderr))
        msg.debug(tostring(stdout))
        return
    end

    if string.find(stdout, "has already been recorded in archive") ~=nil then
        mp.osd_message("Has already been recorded in archive", 5)
        return
    end

    -- Retrieve the file name
    local filename = nil
    if range_mode_file_name == nil and stdout then
        local i, j, last_i, start_index = 0
        while i ~= nil do
            last_i, start_index = i, j
            i, j = stdout:find ("Destination: ",j, true)
        end

        if last_i ~= nil then
          local end_index = stdout:find ("\n", start_index, true)
          if end_index ~= nil and start_index ~= nil then
            filename = trim(stdout:sub(start_index, end_index))
           end
        end
    elseif not_empty(range_mode_file_name) then
        filename = range_mode_file_name
    end

    local osd_text = "Download succeeded\n"
    local osd_time = 5
    -- Find filename or directory
    if filename then
        local filepath
        local basepath
        if filename:find("/") == nil and filename:find("\\") == nil then
          basepath = utils.getcwd()
          filepath = path_join(utils.getcwd(), filename)
        else
          basepath = ""
          filepath = filename
        end

        if filepath:len() < 100 then
            osd_text = osd_text .. ass0 .. "{\\fs12} " .. filepath .. " {\\fs20}" .. ass1
        elseif basepath == "" then
            osd_text = osd_text .. ass0 .. "{\\fs8} " .. filepath .. " {\\fs20}" .. ass1
        else
            osd_text = osd_text .. ass0 .. "{\\fs11} " .. basepath .. "\n" .. filename .. " {\\fs20}" ..  ass1
        end
        if wrote_error_log then
            -- Write filename and end time to log file
            local file = io.open (opts.log_file , "a+")
            file:write("[" .. filepath .. "]\n")
            file:write(os.date("[end %c]\n"))
            file:close()
        end
    else
        if wrote_error_log then
            -- Write directory and end time to log file
            local file = io.open (opts.log_file , "a+")
            file:write("[" .. utils.getcwd() .. "]\n")
            file:write(os.date("[end %c]\n"))
            file:close()
        end
        osd_text = osd_text .. utils.getcwd()
    end

    -- Show warnings
    if not_empty(stderr) then
        msg.warn("Errorlog:" .. tostring(stderr))
        if stderr:find("incompatible for merge") == nil then
            local i = stderr:find("Input #")
            if i ~= nil then
                stderr = stderr:sub(i)
            end
            osd_text = osd_text .. "\n" .. ass0 .. "{\\fs8} " .. stderr:gsub("\r", "") .. ass1
            osd_time = osd_time + 5
        end
    end

    mp.osd_message(osd_text, osd_time)
end

local function select_range_show()
    local status
    if select_range_mode > 0 then
        if select_range_mode == 2 then
            status = "Download range: Fine tune\n← → start time\n↓ ↑ end time\n" ..
                tostring(opts.select_range_binding) .. " next mode"
        elseif select_range_mode == 1 then
            status = "Download range: Select interval\n← start here\n→ end here\n↓from beginning\n↑til end\n" ..
                tostring(opts.select_range_binding) .. " next mode"
        end
        mp.osd_message("Start: " .. start_time_formated .. "\nEnd:  " .. end_time_formated .. "\n" .. status, 30)
    else
        status = "Download range: Disabled (download full length)"
        mp.osd_message(status, 3)
    end
end

local function select_range_set_left()
    if select_range_mode == 2 then
        start_time_seconds = math.max(0, start_time_seconds - 1)
        if start_time_seconds < 86400 then
            start_time_formated = os.date("!%H:%M:%S", start_time_seconds)
        else
            start_time_formated = tostring(start_time_seconds) .. "s"
        end
    elseif select_range_mode == 1 then
        start_time_seconds = mp.get_property_number("time-pos")
        start_time_formated = mp.command_native({"expand-text","${time-pos}"})
    end
    select_range_show()
end

local function select_range_set_start()
    if select_range_mode == 2 then
        end_time_seconds = math.max(1, end_time_seconds - 1)
        if end_time_seconds < 86400 then
            end_time_formated = os.date("!%H:%M:%S", end_time_seconds)
        else
            end_time_formated = tostring(end_time_seconds) .. "s"
        end
    elseif select_range_mode == 1 then
        start_time_seconds = 0
        start_time_formated = "00:00:00"
    end
    select_range_show()
end

local function select_range_set_end()
    if select_range_mode == 2 then
        end_time_seconds = math.min(mp.get_property_number("duration"), end_time_seconds + 1)
        if end_time_seconds < 86400 then
            end_time_formated = os.date("!%H:%M:%S", end_time_seconds)
        else
            end_time_formated = tostring(end_time_seconds) .. "s"
        end
    elseif select_range_mode == 1 then
        end_time_seconds = mp.get_property_number("duration")
        end_time_formated =  mp.command_native({"expand-text","${duration}"})
    end
    select_range_show()
end

local function select_range_set_right()
    if select_range_mode == 2 then
        start_time_seconds = math.min(mp.get_property_number("duration") - 1, start_time_seconds + 1)
        if start_time_seconds < 86400 then
            start_time_formated = os.date("!%H:%M:%S", start_time_seconds)
        else
            start_time_formated = tostring(start_time_seconds) .. "s"
        end
    elseif select_range_mode == 1 then
        end_time_seconds = mp.get_property_number("time-pos")
        end_time_formated = mp.command_native({"expand-text","${time-pos}"})
    end
    select_range_show()
end


local function select_range()
    -- Cycle through modes
    if select_range_mode == 2 then
        -- Disable range mode
        disable_select_range()
    elseif select_range_mode == 1 then
        -- Switch to "fine tune" mode
        select_range_mode = 2
    else
        select_range_mode = 1
        -- Add keybinds for arrow keys
        mp.add_key_binding("up", "select-range-set-up", select_range_set_end)
        mp.add_key_binding("down", "select-range-set-down", select_range_set_start)
        mp.add_key_binding("left", "select-range-set-left", select_range_set_left)
        mp.add_key_binding("right", "select-range-set-right", select_range_set_right)

        -- Defaults
        if start_time_seconds == nil then
            start_time_seconds = mp.get_property_number("time-pos")
            start_time_formated = mp.command_native({"expand-text","${time-pos}"})
            end_time_seconds = mp.get_property_number("duration")
            end_time_formated =  mp.command_native({"expand-text","${duration}"})
        end
    end
    select_range_show()
end

local function download_video()
    return download(DOWNLOAD.VIDEO)
end

local function download_audio()
    return download(DOWNLOAD.AUDIO)
end

local function download_subtitle()
    return download(DOWNLOAD.SUBTITLE)
end

local function download_embed_subtitle()
    return download(DOWNLOAD.VIDEO_EMBED_SUBTITLE)
end

-- keybind
if not_empty(opts.download_video_binding) then
    mp.add_key_binding(opts.download_video_binding, "download-video", download_video)
end
if not_empty(opts.download_audio_binding) then
    mp.add_key_binding(opts.download_audio_binding, "download-audio", download_audio)
end
if not_empty(opts.download_subtitle_binding) then
    mp.add_key_binding(opts.download_subtitle_binding, "download-subtitle", download_subtitle)
end
if not_empty(opts.download_video_embed_subtitle_binding) then
    mp.add_key_binding(opts.download_video_embed_subtitle_binding, "download-embed-subtitle", download_embed_subtitle)
end
if not_empty(opts.select_range_binding) then
    mp.add_key_binding(opts.select_range_binding, "select-range-start", select_range)
end
