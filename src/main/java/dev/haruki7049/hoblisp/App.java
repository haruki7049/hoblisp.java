package dev.haruki7049.hoblisp;

import java.util.concurrent.Callable;
import picocli.CommandLine;

public class App {
  public static void main(String[] args) {
    System.exit(new CommandLine(new HoblispCLI()).execute(args));
  }
}

class HoblispCLI implements Callable<Integer> {
  @CommandLine.Option(
      names = {"-h", "--help"},
      description = "show this help",
      usageHelp = true)
  boolean showHelp;

  @CommandLine.Parameters(paramLabel = "SCRIPT")
  String script;

  @Override
  public Integer call() throws Exception {
    Machine machine = new Machine(script);
    Integer result = machine.eval();

    return result;
  }
}

class Machine {
  String script;

  Machine(String sc) {
    this.script = sc;
  }

  Integer eval() throws Exception {
    System.out.println(String.format("Your script: %s", this.script));

    return 0;
  }
}
