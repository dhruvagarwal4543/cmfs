// Exact multicolour "G" mark from reference_screens/01-auth-login.html's
// "Continue with Google" button — not a brand-colour substitute, since this
// is a third-party logo, not part of CFMS's own colour system.
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _googleLogoSvg = '''
<svg width="16" height="16" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="#4285F4" d="M23 12.3c0-.8-.1-1.6-.2-2.3H12v4.5h6.2a5.3 5.3 0 0 1-2.3 3.5v2.9h3.7c2.2-2 3.4-5 3.4-8.6"/>
  <path fill="#34A853" d="M12 24c3.1 0 5.7-1 7.6-2.8l-3.7-2.9c-1 .7-2.3 1.1-3.9 1.1-3 0-5.5-2-6.4-4.7H1.8v3A12 12 0 0 0 12 24"/>
  <path fill="#FBBC05" d="M5.6 14.7a7.2 7.2 0 0 1 0-4.6v-3H1.8a12 12 0 0 0 0 10.7z"/>
  <path fill="#EA4335" d="M12 4.8c1.7 0 3.2.6 4.4 1.7l3.3-3.3C17.7 1.2 15.1 0 12 0 7.4 0 3.4 2.6 1.8 6.5l3.8 3a7.2 7.2 0 0 1 6.4-4.7"/>
</svg>
''';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_googleLogoSvg, width: size, height: size);
  }
}
