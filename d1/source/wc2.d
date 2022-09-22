import std.algorithm, std.stdio, std.string;
import std.algorithm.iteration;
import std.ascii;
void main(string[] args)
{
    try {
        ulong wordCount = 0;
        //ulong lineCount = 0;
        foreach(line; File(args[1]).byLine)
        {
            line.splitter!(x => isWhite(x)).filter!(w => !w.empty).each!(_ => wordCount++);//(w)  {if (!w.empty) cnt++;});
        }
        writeln(wordCount);
    } catch (Exception e) {
        writeln("Error: ", e);
    }
}
