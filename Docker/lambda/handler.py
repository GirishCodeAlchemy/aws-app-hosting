import json
from typing import Any, Dict

from loguru import logger


def lambda_handler(event: Any, context: Dict):
    try:
        logger.info(f"Recieved Event Message : {json.dumps(event, indent=2)}")

        return {
            "status": "success",
            "msg": f"Received  message: {json.dumps(event)}",
            "status_code": "200",
        }
    except Exception as e:
        logger.error("Exception occurred", e)
