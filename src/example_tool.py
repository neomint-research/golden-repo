#!/usr/bin/env python3
"""Example Tool - Golden Repo Template Python example."""

import argparse
import json
import logging
import sys
from typing import Dict, Any


class ExampleTool:
    """Example tool demonstrating Python best practices."""

    def __init__(self, verbose: bool = False):
        self.logger = self._setup_logging(verbose)
        self.logger.info("ExampleTool initialized")
    

    
    def _setup_logging(self, verbose: bool) -> logging.Logger:
        """Setup logging configuration."""
        logger = logging.getLogger(__name__)
        logger.setLevel(logging.DEBUG if verbose else logging.INFO)

        if not logger.handlers:
            handler = logging.StreamHandler(sys.stdout)
            formatter = logging.Formatter('%(levelname)s - %(message)s')
            handler.setFormatter(formatter)
            logger.addHandler(handler)

        return logger

    def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process input data and return results."""
        self.logger.info("Processing data...")

        if not isinstance(data, dict):
            raise ValueError("Input data must be a dictionary")

        results = {
            "status": "success",
            "input_keys": list(data.keys()),
            "processed_at": "2025-06-20T22:00:00Z",
            "tool_info": {"name": "example-tool", "version": "1.0.0"}
        }

        if "items" in data:
            results["item_count"] = len(data["items"])

        self.logger.info(f"Processing completed. Processed {len(data)} keys.")
        return results
    
    def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Main execution method."""
        try:
            self.logger.info("Starting tool execution")
            results = self.process_data(input_data)
            self.logger.info("Tool execution completed")
            return results
        except Exception as e:
            self.logger.error(f"Execution failed: {e}")
            return {"status": "error", "message": str(e)}


def main():
    """Main entry point for the example tool."""
    parser = argparse.ArgumentParser(description="Example Python tool")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging")
    parser.add_argument("--input", "-i", help="JSON input data")
    args = parser.parse_args()

    # Initialize tool
    tool = ExampleTool(verbose=args.verbose)

    # Prepare input data
    if args.input:
        try:
            input_data = json.loads(args.input)
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON: {e}")
            sys.exit(1)
    else:
        input_data = {"items": ["item1", "item2", "item3"]}

    # Run tool and output results
    results = tool.run(input_data)
    print(json.dumps(results, indent=2))
    sys.exit(0 if results.get("status") == "success" else 1)


if __name__ == "__main__":
    main()
