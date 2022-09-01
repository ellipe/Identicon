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
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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

  def filter_odd_squares(%Image{grid: grid} = identicon) do
    grid = Enum.filter(grid, fn {code, _} -> rem(code, 2) == 0 end)
    %Image{identicon | grid: grid}
  end

  def build_pixel_map(%Image{grid: grid} = identicon) do
    pixel_map =
      Enum.map(grid, fn {_, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Image{identicon | pixel_map: pixel_map}
  end

  def draw_image(%Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
