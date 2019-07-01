defmodule CommandLine.CLI do
  def main([path | _opts]) do
    path
    |> String.trim
    |> list_files
    |> parse_directories
    |> add_directories_to_github(path)
  end

  def list_files(path) do
    System.cmd("ls", [path])
  end

  def parse_directories({ directories, _ }) do
    directories
    |> String.split("\n")
  end

  def add_directories_to_github([], _current_path) do
    IO.inspect "Finished"
  end

  def add_directories_to_github([""], _current_path) do
    IO.inspect "Finished"
  end

  def add_directories_to_github([repo | the_rest], current_path) do
    Task.start fn () ->
      File.cd!("#{current_path}/#{repo}", fn () ->
        IO.inspect "Pushing to #{current_path}/#{repo}"
        repo
        |> set_remote_url
        |> GithubAdapter.create_remote_repo("programming-notes")
        |> push_to_remote
      end)
    end
    :timer.sleep(1000)
    add_directories_to_github(the_rest, current_path)
  end

  def set_remote_url(repo) do
    System.cmd("git", ["remote", "set-url", "origin", "git@github.com:programming-notes/#{repo}.git"])
    repo
  end

  def push_to_remote(_repo) do
    System.cmd("git", ["push", "origin", "master"]) 
  end
end