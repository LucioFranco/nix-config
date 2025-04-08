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

async def run_and_compare(release, seed, log1_path="run1.log", log2_path="run2.log"):
    if not seed:
        seed = random.randint(0, 2**64 - 1)

    print("running seed=" + str(seed))

    cmd = "./target/debug/pc-sim" + " "  + str(seed)

    if release:
        cmd = "./target/release/pc-sim" + " " + str(seed)

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

async def run_cargo_build(release: bool):
    cmd = "cargo build -p pc-sim --release" if release else "cargo build -p pc-sim"
    print(f"Running: {cmd}")
    proc = await asyncio.create_subprocess_shell(cmd)
    await proc.wait()

def main():
    parser = argparse.ArgumentParser(description="Compare output or build with cargo.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Subcommand: compare
    compare_parser = subparsers.add_parser("compare", help="Compare two commands")
    compare_parser.add_argument("--release", action="store_true", help="Use --release flag")
    compare_parser.add_argument("--seed", type=int, help="--seed <seed>")

    args = parser.parse_args()

    if args.command == "compare":
        asyncio.run(run_cargo_build(args.release))
        asyncio.run(run_and_compare(args.release, args.seed))

if __name__ == "__main__":
    main()

