# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class GiboWrapper < Formula
  desc "gibo-wrapper acts like gibo to improve gibo by adding the following features"
  homepage "https://tamada.github.com/gibo-wrapper"
  version "0.5.9"
  license "Unlicense license"

  depends_on "gibo"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tamada/gibo-wrapper/releases/download/v0.5.9/gibo-wrapper_0.5.9_darwin_arm64.tar.gz"
      sha256 "6dccf89f30bf15375217685e5334d32b2b6a4647fbfced9fa8f9c589bd4de228"

      def install
        bin.install "gibo-wrapper"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/tamada/gibo-wrapper/releases/download/v0.5.9/gibo-wrapper_0.5.9_darwin_amd64.tar.gz"
      sha256 "95c5eff1f757c76dcc56c840c395e8eebc41f51030b1e045fae96fe2680a8d2a"

      def install
        bin.install "gibo-wrapper"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/tamada/gibo-wrapper/releases/download/v0.5.9/gibo-wrapper_0.5.9_linux_arm64.tar.gz"
      sha256 "b63b3efd36119f540572006d60544dad3137c30a419d8bdc9954986c9fa69648"

      def install
        bin.install "gibo-wrapper"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/tamada/gibo-wrapper/releases/download/v0.5.9/gibo-wrapper_0.5.9_linux_amd64.tar.gz"
      sha256 "1c2c31f7b17c925b95243a3bb8d70dcfc771098229272ded9fd7191eb2c0de58"

      def install
        bin.install "gibo-wrapper"
      end
    end
  end
end
