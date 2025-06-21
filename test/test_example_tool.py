"""Tests for the example tool."""

import json
import os
import sys
from unittest.mock import patch

import pytest

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

# Import after path modification to avoid flake8 E402
from example_tool import ExampleTool  # noqa: E402


class TestExampleTool:
    """Test cases for ExampleTool class."""

    def test_init_default(self):
        """Test tool initialization with default parameters."""
        tool = ExampleTool()
        assert tool.logger is not None
        assert tool.logger.level == 20  # INFO level

    def test_init_verbose(self):
        """Test tool initialization with verbose logging."""
        tool = ExampleTool(verbose=True)
        assert tool.logger is not None
        assert tool.logger.level == 10  # DEBUG level

    def test_process_data_valid_input(self):
        """Test processing valid input data."""
        tool = ExampleTool()
        input_data = {"key1": "value1", "key2": "value2"}

        result = tool.process_data(input_data)

        assert result["status"] == "success"
        assert result["input_keys"] == ["key1", "key2"]
        assert "processed_at" in result
        assert result["tool_info"]["name"] == "example-tool"
        assert result["tool_info"]["version"] == "1.0.0"

    def test_process_data_with_items(self):
        """Test processing data with items key."""
        tool = ExampleTool()
        input_data = {"items": ["item1", "item2", "item3"], "other": "value"}

        result = tool.process_data(input_data)

        assert result["status"] == "success"
        assert result["item_count"] == 3
        assert "items" in result["input_keys"]
        assert "other" in result["input_keys"]

    def test_process_data_invalid_input(self):
        """Test processing invalid input data."""
        tool = ExampleTool()

        with pytest.raises(ValueError, match="Input data must be a dictionary"):
            tool.process_data("not a dict")

    def test_run_success(self):
        """Test successful tool execution."""
        tool = ExampleTool()
        input_data = {"test": "data"}

        result = tool.run(input_data)

        assert result["status"] == "success"
        assert "input_keys" in result

    def test_run_with_exception(self):
        """Test tool execution with exception."""
        tool = ExampleTool()

        # This should trigger the ValueError in process_data
        result = tool.run("invalid input")

        assert result["status"] == "error"
        assert "Input data must be a dictionary" in result["message"]

    def test_empty_data(self):
        """Test processing empty data."""
        tool = ExampleTool()
        input_data = {}

        result = tool.process_data(input_data)

        assert result["status"] == "success"
        assert result["input_keys"] == []
        assert "item_count" not in result


@pytest.mark.integration
class TestExampleToolIntegration:
    """Integration tests for the example tool."""

    def test_main_function_with_default_data(self):
        """Test main function with default data."""
        with patch("sys.argv", ["example_tool.py"]):
            with patch("sys.exit") as mock_exit:
                with patch("sys.stdout.write") as mock_stdout:
                    from example_tool import main

                    main()

                    # Check that stdout.write was called with JSON output
                    assert mock_stdout.call_count >= 1
                    # Find the JSON output call (should be the last one)
                    json_call = None
                    for call in mock_stdout.call_args_list:
                        if call[0][0].strip().startswith('{'):
                            json_call = call[0][0]
                            break

                    assert json_call is not None, "No JSON output found"
                    result = json.loads(json_call.rstrip('\n'))
                    assert result["status"] == "success"
                    mock_exit.assert_called_once_with(0)

    def test_main_function_with_json_input(self):
        """Test main function with JSON input."""
        test_input = '{"test": "value", "items": ["a", "b"]}'
        with patch("sys.argv", ["example_tool.py", "--input", test_input]):
            with patch("sys.exit") as mock_exit:
                with patch("sys.stdout.write") as mock_stdout:
                    from example_tool import main

                    main()

                    assert mock_stdout.call_count >= 1
                    # Find the JSON output call (should be the last one)
                    json_call = None
                    for call in mock_stdout.call_args_list:
                        if call[0][0].strip().startswith('{'):
                            json_call = call[0][0]
                            break

                    assert json_call is not None, "No JSON output found"
                    result = json.loads(json_call.rstrip('\n'))
                    assert result["status"] == "success"
                    assert result["item_count"] == 2
                    mock_exit.assert_called_once_with(0)

    def test_main_function_with_invalid_json(self):
        """Test main function with invalid JSON input."""
        with patch("sys.argv", ["example_tool.py", "--input", "invalid json"]):
            with patch("sys.exit", side_effect=SystemExit) as mock_exit:
                from example_tool import main

                with pytest.raises(SystemExit):
                    main()

                mock_exit.assert_called_once_with(1)
