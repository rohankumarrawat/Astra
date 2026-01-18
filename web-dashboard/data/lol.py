import requests
import json

def test_stream():
    # URL of your Django view
    url = 'http://127.0.0.1:8000/chatmessage/'
    
    # The JSON payload your view expects
    payload = {
        "message": "Write a short python function to say hello"
    }

    print("--- Starting Stream ---")
    
    try:
        # We set stream=True to handle the StreamingHttpResponse
        response = requests.post(url, json=payload, stream=True)
        
        # Check if the connection was successful
        if response.status_code == 200:
            # Iterate over the response body as it arrives
            for chunk in response.iter_content(chunk_size=None, decode_unicode=True):
                if chunk:
                    # Print each chunk immediately without a newline
                    print(chunk, end='', flush=True)
        else:
            print(f"\nError: Server returned status code {response.status_code}")
            print(response.text)

    except requests.exceptions.ConnectionError:
        print("\nError: Could not connect to the server. Is manage.py runserver running?")
    except Exception as e:
        print(f"\nAn error occurred: {e}")

    print("\n--- Stream Finished ---")

if __name__ == "__main__":
    test_stream()