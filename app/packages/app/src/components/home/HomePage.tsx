import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';
import { Content, InfoCard, Page } from '@backstage/core-components';
import { HomePageCompanyLogo, HomePageStarredEntities, HomePageToolkit } from '@backstage/plugin-home';
import { HomePageSearchBar } from '@backstage/plugin-search';
import { SearchContextProvider } from '@backstage/plugin-search-react';
import HomePageLogo from './logo/HomePageLogo';
import { simpleIcons } from '@dweber019/backstage-plugin-simple-icons';

// The negative margin is required to visually overlap the logo with the search bar for a more compact layout.
// Using theme.spacing ensures consistency and easier maintenance.
const useStyles = makeStyles((theme) => ({
	logoContainer: {
		display: 'flex',
		justifyContent: 'center',
		marginBottom: -theme.spacing(3), // -24px if theme.spacing(1) = 8px
	},
}));

const tools = [
	{
		url: 'https://app.datadoghq.com',
		label: 'Datadog',
		icon: React.createElement(simpleIcons['datadog']),
	},
	{
		url: 'https://github.com',
		label: 'GitHub',
		icon: React.createElement(simpleIcons['github']),
	},
	{
		url: 'https://console.cloud.google.com',
		label: 'Google',
		icon: React.createElement(simpleIcons['googlecloud']),
	},
];

export const HomePage = () => {
	const classes = useStyles();
	return (
		<SearchContextProvider>
			<Page themeId="home">
				<Content>
					<Grid container justifyContent="center" spacing={6}>
						<Grid item xs={12} className={classes.logoContainer}>
							<HomePageCompanyLogo logo={<HomePageLogo />} />
						</Grid>
						<Grid container item xs={12} justifyContent="center">
							<HomePageSearchBar placeholder="Search" />
						</Grid>
						<Grid container item xs={12}>
							<Grid item xs={12} md={6}>
								<HomePageStarredEntities />
							</Grid>
							<Grid item xs={12} md={6}>
								<HomePageToolkit tools={tools} />
							</Grid>
							<Grid item xs={12} md={6}>
								<InfoCard title="Composable Section">
									<div style={{ height: 370 }} />
								</InfoCard>
							</Grid>
						</Grid>
					</Grid>
				</Content>
			</Page>
		</SearchContextProvider>
	);
};
