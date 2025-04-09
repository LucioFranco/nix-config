#!/usr/bin/env python

import argparse
import asyncio
import random


async def read_lines(stream, logfile):
    """Asynchronously read lines from a stream and write to a file."""
    while True:
        line = await stream.readline()
        if not line:
            break
        decoded = line.decode().rstrip('\n')
        logfile.write(decoded + '\n')
        logfile.flush()
        yield decoded

async def run_and_compare(cmd, log1_path="run1.log", log2_path="run2.log"):
    # Start both processes
    proc1 = await asyncio.create_subprocess_shell(
        cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.DEVNULL
    )
    proc2 = await asyncio.create_subprocess_shell(
        cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.DEVNULL
    )

    # Open log files for writing
    with open(log1_path, "w") as log1, open(log2_path, "w") as log2:
        line_num = 1
        async for line1, line2 in async_zip(read_lines(proc1.stdout, log1), read_lines(proc2.stdout, log2)):
            if line1 != line2:
                print(f"Divergence at line {line_num}:")
                print(f"First  run: {line1}")
                print(f"Second run: {line2}")
                proc1.terminate()
                proc2.terminate()
                return
            line_num += 1

        # Check for extra lines
        remaining1 = await proc1.stdout.read()
        remaining2 = await proc2.stdout.read()
        if remaining1 or remaining2:
            print("Outputs differ in length.")
        else:
            print("Outputs are identical.")

async def async_zip(gen1, gen2):
    """Yield pairs of lines from two async generators, stopping when either ends."""
    agen1 = gen1.__aiter__()
    agen2 = gen2.__aiter__()
    while True:
        try:
            line1_task = asyncio.create_task(agen1.__anext__())
            line2_task = asyncio.create_task(agen2.__anext__())
            line1, line2 = await asyncio.gather(line1_task, line2_task)
            yield line1, line2
        except StopAsyncIteration:
            break

def main():
    parser = argparse.ArgumentParser(description="Compare output or build with cargo.")
    parser.add_argument("cmd", type=str, help="command to compare")

    args = parser.parse_args()

    asyncio.run(run_and_compare(args.cmd))

if __name__ == "__main__":
    main()

