require "formula"

HOMEBREW_RRH_VERSION="1.1.0"

class Rrh < Formula
  desc "Git Repository Integrated Manager"
  homepage "https://github.com/tamada/rrh"
  url "https://github.com/tamada/rrh.git", :tag => "v#{HOMEBREW_RRH_VERSION}"
  version HOMEBREW_RRH_VERSION
  head "https://github.com/tamada/rrh.git", :branch => "master"

  depends_on "go"  => :build

  option "without-completions", "Disable bash completions"

  def install
    ENV['GOPATH'] = buildpath
    ENV['GO111MODULE'] = 'on'
    rrh_path = buildpath/"src/github.com/tamada/rrh/"
    rrh_path.install buildpath.children

    cd rrh_path do
      system "make", "build"
      bin.install "rrh"
    end

    test do
      system "make test"
    end

    if build.with? "completions"
      bash_completion.install "src/github.com/tamada/rrh/completions/bash/rrh"
    end
  end
end
