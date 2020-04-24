require "formula"

HOMEBREW_RRH_VERSION="1.2.0"

class Rrh < Formula
  desc "Git Repository Integrated Manager"
  homepage "https://github.com/tamada/rrh"
  url "https://github.com/tamada/rrh/releases/download/v#{HOMEBREW_RRH_VERSION}/rrh-#{HOMEBREW_RRH_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_RRH_VERSION
  sha256 "abab357af44a9e9178bac5040503bdc44dd53bda664b4d3f4acc653a56f97a14"

  option "without-completions", "Disable bash completions"

  def install
    bin.install "bin/rrh"
    bin.install "bin/rrh-new"
    bin.install "bin/rrh-helloworld"

    if build.with? "completions"
      bash_completion.install "completions/bash/rrh"
    end
  end
end
