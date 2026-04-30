from rest_framework.views import exception_handler
from rest_framework import status


def custom_exception_handler(exc, context):
    """
    Custom exception handler that returns consistent error responses
    and prevents cryptic 400 Bad Request errors.
    """
    response = exception_handler(exc, context)

    if response is not None:
        # Customize error response format
        if isinstance(response.data, dict):
            # Extract detailed error information
            error_detail = response.data

            # Format the response
            response.data = {
                'error': 'An error occurred',
                'status_code': response.status_code,
                'details': error_detail
            }

            # If it's a 400 error, provide more helpful messages
            if response.status_code == status.HTTP_400_BAD_REQUEST:
                if 'detail' in error_detail:
                    response.data['error'] = str(error_detail['detail'])
                elif isinstance(error_detail, dict):
                    # Extract first error message
                    for key, value in error_detail.items():
                        if isinstance(value, list) and len(value) > 0:
                            response.data['error'] = f"{key}: {value[0]}"
                            break
        
        return response

    return response
