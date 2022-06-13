VERSION="1.2.0"

class Rrh < Formula
  desc "Repositories, Ready to Hack/Remote Repositories Head/Red Riding Hood"
  homepage "https://github.com/tamada/rrh"
  url "https://github.com/tamada/rrh/releases/download/v#{VERSION}/rrh-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  license "Apache-2.0"
  sha256 "abab357af44a9e9178bac5040503bdc44dd53bda664b4d3f4acc653a56f97a14"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "bin/rrh"
    bin.install "bin/rrh-new"
    bin.install "bin/rrh-helloworld"

    bash_completion.install "completions/bash/rrh" if build.with? "completions"
  end
end
