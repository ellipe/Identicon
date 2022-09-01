defmodule Identicon do
  alias Identicon.Image

  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
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

  def build_grid(%Image{hex: hex_list} = identicon) do
    grid =
      hex_list
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirrow_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Image{identicon | grid: grid}
  end

  def mirrow_row([first, second | _] = row) do
    row ++ [second, first]
  end
end
