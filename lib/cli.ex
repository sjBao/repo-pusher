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

  def add_directories_to_github([repo | _the_rest], current_path) do
    File.cd!("#{current_path}/#{repo}", fn () -> 
      System.cmd("git", ["remote", "set-url", "origin", "git@github.com:programming-notes/#{repo}.git"])
      System.cmd("git", ["push", "origin", "master"]) 
    end)
  end
end