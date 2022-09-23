import std.conv;
import std.random;
import std.stdio;
import std.range : iota;
import std.file;
import std.algorithm.iteration;
import std.array;
import core.exception;
void main(string[] args) {
  try {
    const auto fname = args[1];
    const auto numWords = to!size_t(args[2], 10);
    const auto numLines = to!size_t(args[3], 10);
    auto line = uninitializedArray!(string[])(numWords);
    line[] = "aword ";
    with (File(fname, "w"))
      iota(0, numLines).each!(_ => writeln(line.joiner));
  } catch(Exception e) {
    writeln("Error: ", e);
  }
}
