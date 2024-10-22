import warnings

# Ignore all warnings
warnings.filterwarnings("ignore")

from langchain_ollama.llms import OllamaLLM
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler


def setup_llama():
    """
    Setup Llama 2 with streaming output
    """
    # Initialize Llama 2 with streaming
    llm = OllamaLLM(
        model="llama2",  # Using llama2 model
        temperature=0.7,  # Control randomness (0.0 = deterministic, 1.0 = very random)
        top_p=0.9,       # Nucleus sampling
        num_ctx=4096,    # Context window size
        callbacks=[StreamingStdOutCallbackHandler()],
    )
    return llm


def chat_with_llama():
    """
    Simple chat interface with streaming output
    """
    llm = setup_llama()
    print("\nChat with Llama 2 (type 'quit' to exit)")

    introduction_done = False

    while True:
        
        if(introduction_done == False):
            introduction_done = True
            prompt = f"""[INST] Please introduce yourself [/INST]"""
            print("\nLlama 2: ", end="")
            response = llm.invoke(prompt)
            print(response)
            continue


        user_input = input("\nYou: ")
        if user_input.lower() == 'quit':
            break
        # Adding prompt template for better responses
        prompt = f"""[INST] {user_input} [/INST]"""
        
        # Stream the response
        print("\nLlama 2: ", end="")
        response = llm.invoke(prompt)


if __name__ == "__main__":
    chat_with_llama()
