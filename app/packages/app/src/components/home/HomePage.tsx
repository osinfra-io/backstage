
import { Content, InfoCard, Page } from '@backstage/core-components';
import { HomePageCompanyLogo, HomePageStarredEntities, HomePageToolkit } from '@backstage/plugin-home';
import homeLogo from './logo/home-logo.png';
import { HomePageSearchBar } from '@backstage/plugin-search';
import { SearchContextProvider } from '@backstage/plugin-search-react';
import Grid from '@material-ui/core/Grid';
import React from 'react';

// Temporary Datadog logo icon as a placeholder
const DatadogLogoIcon = () => (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
	<rect width="24" height="24" rx="4" fill="#632CA6"/>
	<text x="50%" y="50%" textAnchor="middle" dy=".3em" fontSize="10" fill="#fff">DD</text>
  </svg>
);

export const HomePage = () => {
	const container = undefined; // Optionally replace with a real class if needed
	return <SearchContextProvider>
		<Page themeId="home">
			<Content>
				<Grid container justifyContent="center" spacing={6}>
					<Grid item xs={12} style={{ display: 'flex', justifyContent: 'center' }}>
						<HomePageCompanyLogo className={container} logo={<img src={homeLogo} style={{ width: '25%', height: 'auto', display: 'block', margin: '0 auto' }} alt="Home Logo" />} />
					</Grid>
					<Grid container item xs={12} justifyContent="center">
						<HomePageSearchBar placeholder="Search" />
					</Grid>
					<Grid container item xs={12}>
						<Grid item xs={12} md={6}>
							<HomePageStarredEntities />
						</Grid>
						<Grid item xs={12} md={6}>
							<HomePageToolkit tools={Array(8).fill({
								url: 'https://app.datadoghq.com',
								label: 'Datadog',
								icon: <DatadogLogoIcon />
							})} />
						</Grid>
						<Grid item xs={12} md={6}>
							<InfoCard title="Composable Section">
								{/* placeholder for content */}
								<div style={{
									height: 370
								}} />
							</InfoCard>
						</Grid>
					</Grid>
				</Grid>
			</Content>
		</Page>
	</SearchContextProvider>;
}
