require "formula"

POCHI_VERSION = "2.0.0"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{POCHI_VERSION}/pochi-#{POCHI_VERSION}_darwin_amd64.tar.gz"
  sha256 "10a9b1473bbce27423ec8d02f91222314caee55b32c6559787114074eb87f465"

  def install
    prefix.install "completions"
    prefix.install "docs"
    prefix.install "examples"
    prefix.install "lib"
    bin.install "bin/pochi"
  end

  def caveats
    <<~EOS
      The examples are available in the #{prefix}/examples
    EOS
  end
end
