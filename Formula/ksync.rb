class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.6",
      revision: "a63f23dba397a540cca9cbde5001afa5cbd8b2ae"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "f850734883bcc35c446bf4da3793300fbd7f7c22f66343e789f0c371759049ff"
    sha256 cellar: :any_skip_relocation, catalina: "b755147d4a3e89ef301de525a88e225e5f2057f8f8a6fdf05d33594bcb48dfe5"
    sha256 cellar: :any_skip_relocation, mojave:   "2268e729463a231c1c61db6a76361628b8c04dc747ce9974ca66e8338db2938a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{Utils.safe_popen_read("date", "+%Y%m%dT%H%M%S").chomp}
      -X #{project}/pkg/ksync.VersionString=Homebrew
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
