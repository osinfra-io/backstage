import {
	createBaseThemeOptions,
	createUnifiedTheme,
	palettes,
} from '@backstage/theme';

import OpenSansCustomFont from '../assets/fonts/OpenSans.ttf';

const openSansCustomFont = {
	fontFamily: 'OpenSans',
	fontStyle: 'normal',
	fontDisplay: 'swap',
	fontWeight: 300,
	src: `
    local('OpenSans'),
    url(${OpenSansCustomFont}) format('truetype'),
  `,
};

export const osinfraTheme = createUnifiedTheme({
	...createBaseThemeOptions({
		palette: {
			...palettes.dark,
			primary: {
				main: '#ffb400',
			},

			secondary: {
				main: '#565a6e',
			},

			background: {
				default: '#1e1e1e',
				paper: '#222222',
			},

			navigation: {
				background: '#1e1e1e',
				indicator: '#ffb400',
				color: '#d5d6db',
				selectedColor: '#ffffff',
			},
		},
	}),

	fontFamily: 'OpenSans',
	defaultPageTheme: 'home',
	components: {
		BackstageHeader: {
			styleOverrides: {
				header: () => ({
					backgroundImage: 'unset',
					boxShadow: 'unset',
				}),
				title: () => ({
					lineHeight: '1.3',
				}),
			},
		},
		MuiCssBaseline: {
			styleOverrides: {
				'@font-face': [openSansCustomFont],

				// Target the specific Backstage sidebar submenu for "My Groups"
				'[class*="BackstageSidebarSubmenu-drawer"]': {
					maxWidth: '400px !important',
					width: '400px !important',
				},

				// Target text elements within the sidebar submenu for line-height
				'[class*="BackstageSidebarSubmenu-drawer"] span': {
					lineHeight: '1.4',
				},
			},
		},
	},
});
