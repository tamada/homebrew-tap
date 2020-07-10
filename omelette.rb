require "formula"

HOMEBREW_OMELETTE_VERSION="1.1.0"

class Omelette < Formula
  desc "An agent for running unit tests/calculating coverages on the CLI environemnt for the Java platform."
  homepage "https://github.com/tamada/omelette"
  url "https://github.com/tamada/omelette/releases/download/v#{HOMEBREW_OMELETTE_VERSION}/omelette-#{HOMEBREW_OMELETTE_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_OMELETTE_VERSION
  sha256 "5b849c3b2f621da6520326aaf079b21de086ca4dc9a7676a6d4593a45089afcb"

  depends_on "bash_completion@2" => :optional
  depends_on "java" => :optional

  option "without-completions", "Disable bash completions"

  def install
    bin.install "bin/omelette"
    system "sh", "./bin/download_dependencies.sh"

    if build.with? "completions"
      bash_completion.install "completions/bash/omelette"
    end
  end
end
