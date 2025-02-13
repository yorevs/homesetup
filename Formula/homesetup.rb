class Homesetup < Formula
  desc "HomeSetup - The ultimate Terminal experience"
  homepage "https://github.com/yorevs/homesetup"
  url "https://github.com/HS-Teams/homebrew-homesetup.git",
      tag: "v1.8.22"
  license "MIT"

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  depends_on "git"
  depends_on "curl"
  depends_on "ruby"
  depends_on "rsync"
  depends_on "vim"
  depends_on "make"
  depends_on "gcc"
  depends_on "tree"
  depends_on "pcre2"
  depends_on "gpg"
  depends_on "base64"
  depends_on "perl"
  depends_on "ruby"
  depends_on "gawk"
  depends_on "python@3.11"
  depends_on "jq"
  depends_on "sqlite3"
  depends_on "hunspell"
  depends_on "ffmpeg"
  depends_on "portaudio"
  depends_on "libmagic"

  def install
    system "bash", "-c", "export HOMEBREW_INSTALLING=1 && ./install.bash"
  end

  def uninstall
    system "bash", "-c", "export HOMEBREW_UNINSTALLING=1 && ./uninstall.bash"
  end

  test do
    system "#{ENV['HOME']}/HomeSetup/bin/apps/bash/hhs-app/hhs.bash", "--version"
  end
end
