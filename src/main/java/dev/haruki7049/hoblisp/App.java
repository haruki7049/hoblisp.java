package dev.haruki7049.hoblisp;

import java.util.concurrent.Callable;
import picocli.CommandLine;

public class App {
  public static void main(String[] args) {
    System.exit(new CommandLine(new HoblispCLI()).execute(args));
  }
}

class HoblispCLI implements Callable<Integer> {
  @CommandLine.Option(names = {"-h", "--help"}, description = "show this help", usageHelp = true)
  boolean showHelp;

  @CommandLine.Parameters(paramLabel = "NAME")
  String name;

  @Override
  public Integer call() throws Exception {
    String message = String.format("Hi, %s!!", this.name);
    System.out.println(message);

    return 0;
  }
}
