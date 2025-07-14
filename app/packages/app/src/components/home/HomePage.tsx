import React from 'react';
import Grid from '@material-ui/core/Grid';
import { Content, InfoCard, Page } from '@backstage/core-components';
import { HomePageCompanyLogo, HomePageStarredEntities, HomePageToolkit } from '@backstage/plugin-home';
import { HomePageSearchBar } from '@backstage/plugin-search';
import { SearchContextProvider } from '@backstage/plugin-search-react';
import HomePageLogo from './logo/HomePageLogo';
import { simpleIcons } from '@dweber019/backstage-plugin-simple-icons';

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

export const HomePage = () => (
	<SearchContextProvider>
		<Page themeId="home">
			<Content>
				<Grid container justifyContent="center" spacing={6}>
					<Grid item xs={12} style={{ display: 'flex', justifyContent: 'center', marginBottom: '-25px' }}>
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
