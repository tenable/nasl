################################################################################
# Copyright (c) 2011-2012, Mak Kolybabi
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

class TestContext < Test::Unit::TestCase
  include Nasl::Test

  # Five is the minimum needed to check all cases (first, after first, middle,
  # before end, end), so do double that for peace of mind.
  @@cols = 5 * 2
  @@rows = 5 * 2

  def grid(pos)
    line = "." * @@cols + "\n"
    grid = line * @@rows
    grid[pos] = "*"

    return grid
  end

  def test_column_beginning_of_line
    0.upto(@@rows - 1) do |row|
      # Calculate the position for the beginning of the line.
      pos = row * (@@cols + 1)

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the column for the current position.
      res = ctx.col(pos)

      # Check that the column is the first one on the line.
      assert_equal(0, res, code)
    end
  end

  def test_column_end_of_line
    0.upto(@@rows - 1) do |row|
      # Calculate the position for the end of the line.
      pos = row * (@@cols + 1) + (@@cols - 1)

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the column for the current position.
      res = ctx.col(pos)

      # Check that the column is the last one on the line.
      assert_equal(@@cols - 1, res, code)
    end
  end

  def test_column_middle_of_line
    0.upto(@@rows - 1) do |row|
      1.upto(@@cols - 2) do |col|
        # Calculate the position of the character on the line.
        pos = row * (@@cols + 1) + col

        # Create the grid for this iteration.
        code = grid(pos)

        # Create a context object with our test grid.
        ctx = context(code)

        # Find the column for the current position.
        res = ctx.col(pos)

        # Check that the column is the expected one.
        assert_equal(col, res, code)
      end
    end
  end

  def test_row_beginning_of_code
    0.upto(@@cols - 1) do |col|
      # Calculate the position on the first line.
      pos = col

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the row for the current position.
      res = ctx.row(pos)

      # Check that the column is the first one on the line.
      assert_equal(1, res, code)
    end
  end

  def test_row_end_of_code
    0.upto(@@cols - 1) do |col|
      # Calculate the position on the last line.
      pos = (@@rows - 1) * (@@cols + 1) + col

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the row for the current position.
      res = ctx.row(pos)

      # Check that the column is the last one on the line.
      assert_equal(@@rows, res, code)
    end
  end

  def test_row_middle_of_code
    1.upto(@@rows - 2) do |row|
      0.upto(@@cols - 1) do |col|
        # Calculate the position of the character on the line.
        pos = row * (@@cols + 1) + col

        # Create the grid for this iteration.
        code = grid(pos)

        # Create a context object with our test grid.
        ctx = context(code)

        # Find the column for the current position.
        res = ctx.row(pos)

        # Check that the column is the expected one.
        assert_equal(row + 1, res, code)
      end
    end
  end

  def test_single_ctx_line_beginning_of_code
    0.upto(@@cols - 1) do |col|
      # Calculate the position on the first line.
      pos = col

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the default context for the current position.
      res = ctx.context(pos..pos + 1, nil, false, false)

      # Check that the context is the entire first line.
      assert_equal(code.split.first << "\n", res, code)
    end
  end

  def test_single_ctx_line_end_of_code
    0.upto(@@cols - 1) do |col|
      # Calculate the position on the last line.
      pos = (@@rows - 1) * (@@cols + 1) + col

      # Create the grid for this iteration.
      code = grid(pos)

      # Create a context object with our test grid.
      ctx = context(code)

      # Find the default context for the current position.
      res = ctx.context(pos..pos + 1, nil, false, false)

      # Check that the context is the entire last line.
      assert_equal(code.split.last << "\n", res, code)
    end
  end

  def test_single_ctx_middle_of_code
    1.upto(@@rows - 2) do |row|
      0.upto(@@cols - 1) do |col|
        # Calculate the position of the character on the line.
        pos = row * (@@cols + 1) + col

        # Create the grid for this iteration.
        code = grid(pos)

        # Create a context object with our test grid.
        ctx = context(code)

        # Find the default context for the current position.
        res = ctx.context(pos..pos + 1, nil, false, false)

        # Check that the context is the entire last line.
        assert_equal(code.split[row] << "\n", res, code)
      end
    end
  end

  def test_all_ctx_all_of_code
    0.upto(@@rows - 1) do |row|
      0.upto(@@cols - 1) do |col|
        # Calculate the position of the character on the line.
        pos = row * (@@cols + 1) + col

        # Create the grid for this iteration.
        code = grid(pos)

        # Create a context object with our test grid.
        ctx = context(code)

        # Find the full context for the current position.
        res = ctx.context(pos..pos + 1, 0..-1, false, false)

        # Check that the context is the entire grid.
        assert_equal(code, res, code)
      end
    end
  end
end
