defmodule GithubAdapter do

  def create_remote_repo(repo_name, org_name) do
    org_name
    |> github_api_org_url
    |> HTTPoison.post(repo_body(repo_name), headers)

    repo_name
  end

  ## private functions
  defp github_api_base_url do
    "https://api.github.com"
  end

  defp github_api_org_url(org_name) do
    github_api_base_url <> "orgs/#{org_name}/repos"
  end

  defp repo_body(repo_name) do
    Jason.encode! %{
      name: repo_name,
      private: false,
      has_issues: true,
      has_projects: false,
      has_wiki: false
    }
  end

  defp headers do
    [{"Authorization", "token #{System.get_env("GIT_TOKEN")}"}]
  end
end