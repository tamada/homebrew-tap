VERSION="{{ release.tagName }}"

class Sibling < Formula
  desc "get next/previous sibling directory name."
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
    {%- endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
  {%- endfor %}

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
