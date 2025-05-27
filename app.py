from flask import Flask, request, jsonify, send_from_directory
from transformers import ViTImageProcessor, AutoModelForImageClassification, pipeline
from PIL import Image
import io
import torch

app = Flask(__name__)

# Load model and processor
processor = ViTImageProcessor.from_pretrained("Falconsai/nsfw_image_detection")
model = AutoModelForImageClassification.from_pretrained(
    "Falconsai/nsfw_image_detection"
)


@app.route("/")
def index():
    return send_from_directory(".", "index.html")


@app.route("/predict", methods=["POST"])
def predict():
    try:
        # Check if image is in request
        if "file" not in request.files:
            return jsonify({"error": "No image provided"}), 400

        file = request.files["file"]
        if file.filename == "":
            return jsonify({"error": "No selected file"}), 400

        # Read and process image
        image_bytes = file.read()
        image = Image.open(io.BytesIO(image_bytes))

        classifier = pipeline(
            "image-classification", model="Falconsai/nsfw_image_detection"
        )
        results = classifier(image)

        return jsonify({"results": results})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
