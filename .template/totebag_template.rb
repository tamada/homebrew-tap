{{- $r := .Release -}}
VERSION="{{ toVersion $r.TagName }}"

class Totebag < Formula
  desc "{{ .Description }}"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/{{ .RepoName }}"
  version VERSION
  license "{{ .License }}"

  {{- $DARWIN_AMD64 := "" -}}
  {{- $DARWIN_ARM64 := "" -}}
  {{- $LINUX_AMD64 := "" -}}
  {{- $LINUX_ARM64 := "" -}}
  {{- range $asset := $r.Assets -}}
    {{- if isAsset $asset "darwin" "amd64" -}}
      {{- $DARWIN_AMD64 = $asset.Url -}}
    {{- end }}
    {{- if isAsset $asset "darwin" "arm64" -}}
      {{- $DARWIN_ARM64 = $asset.Url -}}
    {{- end }}
    {{- if isAsset $asset "linux" "amd64" -}}
      {{- $LINUX_AMD64 = $asset.Url -}}
    {{- end }}
    {{- if isAsset $asset "linux" "arm64" -}}
      {{- $LINUX_ARM64 = $asset.Url -}}
    {{- end }}
  {{- end }}

  {{- if ne $DARWIN_AMD64 "" }}
  if OS.mac? && Hardware::CPU.intel?
    url "{{ $DARWIN_AMD64 }}"
    sha256 "{{ sha256 $DARWIN_AMD64 }}"
  end
  {{- end }}

  {{- if ne $DARWIN_ARM64 "" }}
  if OS.mac? && Hardware::CPU.arm?
    url "{{ $DARWIN_ARM64 }}"
    sha256 "{{ sha256 $DARWIN_ARM64 }}"
  end
  {{- end }}

  {{- if ne $LINUX_AMD64 "" }}
  if OS.linux? && Hardware::CPU.intel?
    url "{{ $LINUX_AMD64 }}"
    sha256 "{{ sha256 $LINUX_AMD64 }}"
  end
  {{- end }}

  {{- if ne $LINUX_ARM64 "" }}
  if OS.linux? && Hardware::CPU.arm?
    url "{{ $LINUX_ARM64 }}"
    sha256 "{{ sha256 $LINUX_ARM64 }}"
  end
  {{- end }}

  def install
    bin.install "{{ .Name }}"

    bash_completion.install "completions/bash/{{ .Name }}" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_{{ .Name }}" if build.with? "completions"
    fish_completion.install "completions/fish/{{ .Name }}" if build.with? "completions"
  end

  test do
    system "#{bin}/{{ .Name }} --version"
  end
end
