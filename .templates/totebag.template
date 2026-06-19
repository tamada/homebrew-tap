VERSION="{{ release.tagName | to_version }}"

class Totebag < Formula
  desc "{{ project.description }}"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
  if OS.mac? && Hardware::CPU.intel?
    {%- endif %}
    {%- if "darwin" in asset.name and "arm64" in asset.name %}
  if OS.mac? && Hardware::CPU.arm?
    {%- endif %}
    {%- if "linux" in asset.name and "amd64" in asset.name %}
  if OS.linux? && Hardware::CPU.intel?
    {%- endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    {%- endif %}
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
  {%- endfor %}

  def install
    bin.install "{{ project.name }}"

    bash_completion.install "assets/completions/bash/{{ project.name }}" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_{{ project.name }}" if build.with? "completions"
    fish_completion.install "assets/completions/fish/{{ project.name }}" if build.with? "completions"
  end

  test do
    system "#{bin}/{{ project.name }} --version"
  end
end
