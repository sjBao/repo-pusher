defmodule CommandLine.CLI do
  def main([repos_dir, org_name | _opts]) do
    repos_dir
    |> String.trim
    |> list_files
    |> parse_directories
    |> add_directories_to_github(repos_dir, org_name)
  end

  def list_files(path) do
    System.cmd("ls", [path, "-1 -d \"$PWD\"*"])
  end

  def parse_directories({ directories, _ }) do
    directories
    |> String.split("\n")
  end

  def add_directories_to_github([], _, _) do
    IO.inspect "Finished"
  end

  def add_directories_to_github([""], _, _) do
    IO.inspect "Finished"
  end

  def add_directories_to_github([repo | the_rest], repos_dir, org_name) do
    Task.start fn () ->
      File.cd!("#{repos_dir}/#{repo}", fn () ->
        IO.inspect "Initating push of #{repos_dir}/#{repo}... to https://github.com/#{org_name}"
        repo
        |> set_remote_url(org_name)
        |> GithubAdapter.create_remote_repo(org_name)
        |> push_to_remote
      end)
    end
    :timer.sleep(1000)
    add_directories_to_github(the_rest, repos_dir, org_name)
  end



  defp set_remote_url(repo, org_name) do
    System.cmd("git", ["remote", "set-url", "origin", "git@github.com:#{org_name}/#{repo}.git"])
    repo
  end

  defp push_to_remote(_repo) do
    System.cmd("git", ["push", "origin", "master"]) 
  end
end