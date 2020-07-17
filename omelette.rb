require "formula"

HOMEBREW_OMELETTE_VERSION="1.1.1"

class Omelette < Formula
  desc "An agent for running unit tests/calculating coverages on the CLI environemnt for the Java platform."
  homepage "https://github.com/tamada/omelette"
  url "https://github.com/tamada/omelette/releases/download/v#{HOMEBREW_OMELETTE_VERSION}/omelette-#{HOMEBREW_OMELETTE_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_OMELETTE_VERSION
  sha256 "a2c0f51c13fc46686a6ae6ae1ceaf02a1b8b37c547a3f6cf91922bc7c9b52a65"

  depends_on "bash_completion@2" => :optional
  depends_on "java" => :optional

  option "without-completions", "Disable bash completions"

  def install
    bin.install "bin/omelette"
    system "sh", "./bin/download_dependencies.sh"

    lib.install "lib/jacocoagent.jar"
    lib.install "lib/jacococli.jar"
    lib.install "lib/junit4"

    if build.with? "completions"
      bash_completion.install "completions/bash/omelette"
    end
  end
end
