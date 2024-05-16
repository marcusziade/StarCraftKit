import Foundation

func printInstructions() {
    print()
    print("👾 Welcome to StarCraftCLI 👾")
    print()
    print("Commands:")
    print("-m   all matches")
    print("-ot  ongoing tournaments")
    print("-ut  upcoming tournaments")
    print("-lt  live supported tournaments")
    print("-om  ongoing matches")
    print()
    print("You must provide a valid PANDA_TOKEN environment variable")
    print()
    print("Usage: swift build, swift run StarCraftCLI <command>")
    print("Example: swift run StarCraftCLI -t. This will fetch all tournaments")
}

