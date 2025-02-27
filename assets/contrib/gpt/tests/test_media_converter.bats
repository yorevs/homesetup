#!/usr/bin/env bats

# test_media_converter.bats
# Purpose: Tests for Media converter script

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

setup() {
    SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/media-converter.bash"
    MEDIA_FILES="${HHS_HOME}/assets/devel/scripts/gpt/tests/resources"
}

# @purpose: Test for conversion of an audio file to another format (mp3 to wav)
@test "Convert audio file from mp3 to wav" {
    run "${SCRIPT}" -i "${MEDIA_FILES}/audio-1.mp3" -f wav > /dev/null
    [ -f "${MEDIA_FILES}/audio-1.wav" ]
    rm -f "${MEDIA_FILES}/audio-1.wav"
}

# @purpose: Test for conversion of a video file to another format (mov to mp4)
@test "Convert video file from mov to mp4" {
    run "${SCRIPT}" -i "${MEDIA_FILES}/video-1.mov" -f mp4 > /dev/null
    [ -f "${MEDIA_FILES}/video-1.mp4" ]
    rm -f "${MEDIA_FILES}/video-1.mp4"
}

# @purpose: Test for custom output file name (mp3 to wav)
@test "Convert audio file with a custom output file name" {
    run "${SCRIPT}" -i "${MEDIA_FILES}/audio-1.mp3" -o "${MEDIA_FILES}/custom-audio.wav" -f wav > /dev/null
    [ -f "${MEDIA_FILES}/custom-audio.wav" ]
    rm -f "${MEDIA_FILES}/custom-audio.wav"
}

# @purpose: Test script fails when no format is provided
@test "Fail when no format is provided" {
    run "${SCRIPT}" -i "${MEDIA_FILES}/audio-1.mp3"
    assert_failure
    # Assert that the cleaned stderr output contains the expected error message
    assert_output --partial "Input file and format are required."
}

# @purpose: Test script fails when no input file is provided
@test "Fail when no input file is provided" {
    run "${SCRIPT}" -f mp3
    assert_failure
    # Assert that the cleaned stderr output contains the expected error message
    assert_output --partial "Input file and format are required."
}


# @purpose: Test version output
@test "Display version information" {
    run "${SCRIPT}" -v
    assert_output --partial "media-converter.bash version 0.0.1"
}

# @purpose: Test help message output
@test "Display help message" {
    run "${SCRIPT}" -h
    assert_output --partial "usage:"
}
