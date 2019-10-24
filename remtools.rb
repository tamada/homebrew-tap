require "formula"

HOMEBREW_REMTOOLS_VERSION="5.0.0"

class Rrh < Formula
  desc "move backup files to trashbox, and list/empty trash"
  homepage "https://github.com/tamada/remtools"
  url "https://github.com/tamada/remtools.git", :tag => "v#{HOMEBREW_REMTOOLS_VERSION}"
  version HOMEBREW_REMTOOLS_VERSION
  head "https://github.com/tamada/remtools.git", :branch => "master"

  depends_on "go"  => :build

  option "without-completions", "Disable bash completions"

  def install
    ENV['GOPATH'] = buildpath
    ENV['GO111MODULE'] = 'on'
    remtools_path = buildpath/"src/github.com/tamada/remtools/"
    remtools_path.install buildpath.children

    cd remtools_path do
      system "make", "build"
      bin.install "remrem"
      bin.install "lsrem"
      bin.install "rem"
    end

    test do
      system "make test"
    end

    if build.with? "completions"
      bash_completion.install "src/github.com/tamada/remtools/completions/bash/remtools"
    end
  end
end
