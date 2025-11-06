VERSION="{{ release.tagName }}"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
  if OS.mac? && Hardware::CPU.intel?
    {%- elif "darwin" in asset.name and "arm64" in asset.name %}
  if OS.mac? && Hardware::CPU.arm?
    {%- elif "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    {%- elif "windows" in asset.name and "arm64" in asset.name %}
  if OS.windows? && Hardware::CPU.arm?
    {%- elif "linux" in asset.name %}
  if OS.linux? && Hardware::CPU.intel?
    {%- else %}
  if OS.windows? && Hardware::CPU.intel?
    {%- endif %}
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
  {%- endfor %}

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "wildcat"

    prefix.install_metafiles
    prefix.install "docs"

    bash_completion.install "completions/bash/wildcat.bash" if build.with? "completions"
  end

  test do
      system bin/"wildcat", "--version"
  end
end
