VERSION="{{ release.tagName | to_version }}"

class GiboWrapper < Formula
  desc "gibo-wrapper acts like gibo to improve gibo by adding the following features"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional
  depends_on "gibo"

  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
  if OS.mac? && Hardware::CPU.intel?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
    {%- if "darwin" in asset.name and "arm64" in asset.name %}
  if OS.mac? && Hardware::CPU.arm?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
    {%- if "linux" in asset.name and "amd64" in asset.name %}
  if OS.linux? && Hardware::CPU.intel?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {% endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
  {%- endfor %}

  def install
    bin.install "gibo-wrapper"

    bash_completion.install "completions/bash/gibo" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_gibo" if build.with? "completions"
    fish_completion.install "completions/fish/gibo" if build.with? "completions"
  end

  test do
    system "#{bin}/gibo-wrapper --version"
  end

  def caveats
    <<~EOS
      Put the following alias setting into your shell configuration file.
          alias gibo='gibo-wrapper $@'
    EOS
  end
end
