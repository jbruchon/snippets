Helpful snippets by Jody Bruchon <jody@jodybruchon.com>

https://github.com/jbruchon/snippets

This is a bunch of helpful stuff that I wrote, often for other projects, all
put together into one "project" for more convenient distribution and hopefully
discovery by others who can use something here. I've tried to shove as much as
I can under The MIT License for maximum reuse potential. Anything without an
explicit license declaration or reference at the top of the file should be
assumed to be released under The MIT License (see the file LICENSE-MIT)

Two (totally optional) requests:

1. If you use something here, let me know: jody@jodybruchon.com is always open!

2. If this is useful to you, please consider using my support links found on
   jodybruchon.com to support my work with a one-time or recurring donation.

Happy hacking!


***** DESCRIPTION OF SOME SNIPPETS *****

6502 CPU assembly code (in ACME Cross-Assembler format)
-------------------------------------------------------
6502/byte2bin: convert a byte to an 8-character string of binary digits
6502/blockmove: move a block of memory (including sizes over >256 bytes)
6502/detect6502: detect what variant of 6502/65816 CPU is in use
6502/divide_16-8-8: divide 16-bit number by 8-bit number
6502/divide_8-8-8: divide 8-bit number by 8-bit number
6502/multiply_8-8-16: multiply two 8-bit numbers
6502/pagefill: fill a 1-256 byte area of memory with a value
6502/pagemove: move a block of memory (256 bytes or less)
6502/nes: bootstrapping code for a basic Nintendo Entertainment System ROM

Batch files for Windows Command Prompt
--------------------------------------
batch_files/clear_event_logs.bat
    clear all possible Event Viewer logs in Windows
batch_files/companionlink_revival_kit:
    script to watch-and-restart CompanionLink (or anything you edit it for)
batch_files/compress_win10_with_lzx.bat
    compress Windows and program files with LZX
batch_files/compress_win10_with_lzx_unattended.bat
    same as above, but use nircmdc (nirsoft.net) to run minimized
batch_files/delete_unused_driver_packages.bat
    delete all third-party drivers no longer associated with any devices
batch_files/extract_audio_to_wav:
    use ffmpeg to pull the first audio track out of a video file (to WAV)
batch_files/fix_win10_recovery_on_c.bat
    for moving Windows Recovery Environment from a recovery partition to C:
    copy the RE partition \Recovery contents to C:\Recovery then run this
batch_files/reset_print_spooler.bat
    stops print spooler, force-deletes all print jobs, restarts the spooler
    super handy for clearing a "stuck" print job that blocks all printing

C functions (and header files to use them)
------------------------------------------
c/byteplane_xfrm: byte-plane transform from lzjody (see byteplane_xfrm.png)
c/jody_cacheinfo: get cpu0 cache sizes from standard sysfs path on Linux
c/jody_endian: endianness detection and conversion (untested)
c/jody_paths: pathname processing functions used in jdupes for link names
c/jody_sort: numerically correct file name compare function (for sorting)
c/jody_string: str[n][case]cmp that returns only equality (faster)
c/jody_strstr: two-way strstr() that is relatively fast and quite small
c/jody_strtoepoch: convert datetime string to seconds since the epoch
c/jody_win_unicode: Windows Unicode helpers for aiding portability
c/strcat_fixed: a faster strcat() for when string length is already known
c/string_malloc: a simple, fast memory allocator for small pieces  of data
c/win_stat: Windows stat() and NT-to-UNIX epoch portability helper code
c/xorpipe: XORs the data in a pipeline by a 32-bit key

Windows MRU (Most Recently Used) Clear
--------------------------------------
The registry and batch files in MRU Clear are used to wipe various Windows
registry entries that track files, folders, and programs you've used. They
can sometimes have surpising side effects, so be careful!

Shell scripts (POSIX sh and/or GNU Bash)
----------------------------------------
shell_scripts/ansicolors:
    ANSI color escape sequences for shell script echo
shell_scripts/change_hplj_status:
    change READY message on old HP LaserJet printer displays
shell_scripts/clean_mpchc_thumbnail_names:
    remove some of the junk in MPC-HC thumbnail image file names
shell_scripts/convert_all_to_xz:
    convert all .tar.* packages to .tar.xz and report saved space
shell_scripts/colordiff:
    colorize diff output, but without needing Perl like colordiff.org
shell_scripts/count_total_files_in_directory:
    shows how many files are under each subdirectory of the current one
shell_scripts/gather_file_dir_statistics:
    shows various file/directory stats, including avg/min/max file size
shell_scripts/git_pull_all:
    in a directory of Git project directories, enter each and 'git pull'
shell_scripts/remove_empty_dirs:
    delete all empty directories underneath a specified directory
shell_scripts/refresh_directories:
    attempt to defragment a directory while preserving date and permissions

--- YouTube archive management scripts ---
Read the README.txt in shell_scripts/youtube_archive/ for full explanations
Not all scripts will be mentioned below!
shell_scripts/youtube_archive/count_files_in_dirs:
    show count of files in all subdirectories, excluding their subdirs
shell_scripts/youtube_archive/find_video_files_without_audio:
    scan entire archive for video files with missing audio tracks
shell_scripts/youtube_archive/create_quantity_dirscores:
    make quantity-weighted per-dir scores from scores.txt file
shell_scripts/youtube_archive/score_video_files:
    "score" how much space will be saved by transcoding video files
shell_scripts/youtube_archive/translate_scores_to_dir_scores:
    make per-directory scores from a score_video_files "scores.txt" file
