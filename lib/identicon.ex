defmodule Identicon do
  alias Identicon.Image

  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Image{hex: hex}
  end

  def pick_color(%Image{hex: [r, g, b | _]} = identicon) do
    %Image{identicon | color: {r, g, b}}
  end
end
