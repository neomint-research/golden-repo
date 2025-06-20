#!/usr/bin/env python3
"""
Example Tool - Demonstrates proper Python tool structure for the golden-repo template.

This file serves as an example of how to structure Python tools in this template.
It follows best practices for:
- Code organization and documentation
- Error handling and logging
- Configuration management
- Testing and validation

Usage:
    python src/example_tool.py --config config.json --verbose
    python src/example_tool.py --help
"""

import argparse
import json
import logging
import sys
from pathlib import Path
from typing import Dict, Any, Optional


class ExampleTool:
    """
    Example tool class demonstrating proper structure and patterns.
    
    This class shows how to:
    - Initialize with configuration
    - Handle errors gracefully
    - Log operations appropriately
    - Provide clear interfaces
    """
    
    def __init__(self, config_path: Optional[str] = None, verbose: bool = False):
        """
        Initialize the example tool.
        
        Args:
            config_path: Path to configuration file (optional)
            verbose: Enable verbose logging
        """
        self.config = self._load_config(config_path)
        self.logger = self._setup_logging(verbose)
        self.logger.info("ExampleTool initialized")
    
    def _load_config(self, config_path: Optional[str]) -> Dict[str, Any]:
        """Load configuration from file or use defaults."""
        default_config = {
            "name": "example-tool",
            "version": "1.0.0",
            "settings": {
                "max_retries": 3,
                "timeout": 30,
                "output_format": "json"
            }
        }
        
        if config_path and Path(config_path).exists():
            try:
                with open(config_path, 'r') as f:
                    user_config = json.load(f)
                    # Merge with defaults
                    default_config.update(user_config)
            except (json.JSONDecodeError, IOError) as e:
                print(f"Warning: Could not load config from {config_path}: {e}")
                print("Using default configuration")
        
        return default_config
    
    def _setup_logging(self, verbose: bool) -> logging.Logger:
        """Setup logging configuration."""
        logger = logging.getLogger(__name__)
        logger.setLevel(logging.DEBUG if verbose else logging.INFO)
        
        if not logger.handlers:
            handler = logging.StreamHandler(sys.stdout)
            formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
            )
            handler.setFormatter(formatter)
            logger.addHandler(handler)
        
        return logger
    
    def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process input data and return results.
        
        Args:
            data: Input data to process
            
        Returns:
            Processed results
            
        Raises:
            ValueError: If input data is invalid
        """
        self.logger.info("Processing data...")
        
        if not isinstance(data, dict):
            raise ValueError("Input data must be a dictionary")
        
        # Example processing logic
        results = {
            "status": "success",
            "input_keys": list(data.keys()),
            "processed_at": "2025-06-20T22:00:00Z",
            "tool_info": {
                "name": self.config["name"],
                "version": self.config["version"]
            }
        }
        
        # Simulate some processing
        if "items" in data:
            results["item_count"] = len(data["items"])
            results["processed_items"] = [
                {"id": i, "processed": True} 
                for i in range(len(data["items"]))
            ]
        
        self.logger.info(f"Processing completed successfully. Processed {len(data)} keys.")
        return results
    
    def validate_input(self, data: Dict[str, Any]) -> bool:
        """
        Validate input data format.
        
        Args:
            data: Data to validate
            
        Returns:
            True if valid, False otherwise
        """
        required_fields = ["type", "data"]
        
        for field in required_fields:
            if field not in data:
                self.logger.error(f"Missing required field: {field}")
                return False
        
        if not isinstance(data["data"], (dict, list)):
            self.logger.error("Data field must be dict or list")
            return False
        
        self.logger.debug("Input validation passed")
        return True
    
    def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Main execution method.
        
        Args:
            input_data: Input data to process
            
        Returns:
            Processing results
        """
        try:
            self.logger.info("Starting tool execution")
            
            if not self.validate_input(input_data):
                return {"status": "error", "message": "Input validation failed"}
            
            results = self.process_data(input_data["data"])
            results["validation"] = "passed"
            
            self.logger.info("Tool execution completed successfully")
            return results
            
        except Exception as e:
            self.logger.error(f"Tool execution failed: {e}")
            return {
                "status": "error",
                "message": str(e),
                "type": type(e).__name__
            }


def main():
    """Main entry point for the example tool."""
    parser = argparse.ArgumentParser(
        description="Example tool demonstrating proper Python structure",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    %(prog)s --config config.json --verbose
    %(prog)s --input '{"type": "test", "data": {"items": [1, 2, 3]}}'
        """
    )
    
    parser.add_argument(
        "--config", "-c",
        help="Path to configuration file"
    )
    
    parser.add_argument(
        "--input", "-i",
        help="JSON input data to process"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose logging"
    )
    
    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s 1.0.0"
    )
    
    args = parser.parse_args()
    
    # Initialize tool
    tool = ExampleTool(config_path=args.config, verbose=args.verbose)
    
    # Prepare input data
    if args.input:
        try:
            input_data = json.loads(args.input)
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON input: {e}")
            sys.exit(1)
    else:
        # Default example data
        input_data = {
            "type": "example",
            "data": {
                "items": ["item1", "item2", "item3"],
                "metadata": {
                    "source": "example",
                    "timestamp": "2025-06-20T22:00:00Z"
                }
            }
        }
    
    # Run tool
    results = tool.run(input_data)
    
    # Output results
    print(json.dumps(results, indent=2))
    
    # Exit with appropriate code
    sys.exit(0 if results.get("status") == "success" else 1)


if __name__ == "__main__":
    main()
