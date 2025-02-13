class Homesetup < Formula
  desc "HomeSetup - The ultimate Terminal experience"
  homepage "https://github.com/HS-Teams/homebrew-homesetup"
  url "https://github.com/HS-Teams/homebrew-homesetup/archive/v1.8.22.tar.gz"
  sha256 "5a2f2c42f0038167fccdaf59cc8af59cc3aa7c2c2d0f3532e5724098196bff7f"
  license "MIT"
  head "https://github.com/HS-Teams/homebrew-homesetup.git", branch: "master"

  def install
    system "bash", "-c", "curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash"
  end

  test do
    system "#{ENV['HOME']}/HomeSetup/bin/apps/bash/hhs-app/hhs.bash", "--version"
  end
end
