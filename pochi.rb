require "formula"

POCHI_VERSION = "1.0.0"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v1.0.0/pochi-#{POCHI_VERSION}-dist.zip"
  sha256 "bfacde1d8335d3402d69b98a5830f454b3a692722f6b126c73b7a05c145f6d76"

  def install
      (bin/"pochi").write <<~EOS
        #! /bin/sh
        exec #{libexec}/bin/pochi.sh "$@"
      EOS
      libexec.install "lib"
      libexec.install "bin"
  end
end
