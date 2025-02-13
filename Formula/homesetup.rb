class Homesetup < Formula
  desc "HomeSetup - The ultimate Terminal experience"
  homepage "https://github.com/HS-Teams/homebrew-homesetup"
  url "https://github.com/HS-Teams/homebrew-homesetup/archive/v1.8.22.tar.gz"
  sha256 "your_tarball_sha256_here"
  license "MIT"

  depends_on "dependency" => :build

  def install
    system "bash", "-c", "curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash"
  end

  test do
    system "#{ENV['HOME']}/HomeSetup/bin/apps/bash/hhs-app/hhs.bash", "--version"
  end
end
