#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 29 10:46:23 2024

@author: leonefamily
"""

import sys
import yaml
import argparse
from typing import List, Optional


def parse_args(
        args_source: Optional[List[str]] = None
) -> argparse.Namespace:
    if args_source is None:
        args_list = sys.argv[1:]
    else:
        args_list = args_source

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-i', '--input-path',
        required=True,
        help='Path to the initial YAML config file'
    )
    parser.add_argument(
        '-w', '--working-directory',
        required=True,
        help='Working directory in config'
    )
    parser.add_argument(
        '-f', '--flowchart-path',
        required=True,
        help='Flowchart save path in config'
    )
    parser.add_argument(
        '-d', '--data-directory',
        required=True,
        help='Where data for synthesis are located'
    )
    parser.add_argument(
        '-o', '--output-path',
        required=True,
        help='Where to save the resulting YAML config file'
    )
    args = parser.parse_args(args_list)
    return args


def main(
        input_path: str,
        working_directory: str,
        flowchart_path: str,
        data_directory: str,
        output_path: str
):
    with open(input_path, mode='r') as f:
        config = yaml.safe_load(f)

    config['working_directory'] = working_directory
    config['flowchart_path'] = flowchart_path
    config['config']['data_path'] = data_directory

    with open(output_path, mode='w', encoding='utf-8') as f:
        yaml.dump(config, f)


if __name__ == '__main__':
    args = parse_args()
    main(
        input_path=args.input_path,
        working_directory=args.working_directory,
        flowchart_path=args.flowchart_path,
        data_directory=args.data_directory,
        output_path=args.output_path
    )
