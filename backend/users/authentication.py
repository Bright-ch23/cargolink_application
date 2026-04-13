from rest_framework_simplejwt.authentication import JWTAuthentication


class CompatibleJWTAuthentication(JWTAuthentication):
    """
    Accept both "Bearer <token>" and legacy "Token <token>" headers.
    """

    def get_header(self, request):
        header = super().get_header(request)
        if not header:
            return header

        parts = header.split()
        if len(parts) == 2 and parts[0].lower() == b'token':
            return b'Bearer ' + parts[1]

        return header
