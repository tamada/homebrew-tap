require "formula"

HOMEBREW_NINERULES_VERSION="1.0.0"

class NineRules < Formula
  desc "Checking tool of small object programming for the Java language"
  homepage "https://github.com/tamada/9rules"
  url "https://github.com/tamada/9rules.git", :tag => "v#{HOMEBREW_NINERULES_VERSION}"
  version HOMEBREW_NINERULES_VERSION
  head "https://github.com/tamada/9rules.git", :branch => "master"

  def script; <<~EOF
    #!/bin/sh
    cd #{libexec} && bin/9rules.sh "$@"
    EOS
  end

  def install
    cd 9rules_path do
      system "mvn", "package"
      bin.install "src/script/9rules.sh"
    end
  end
end
