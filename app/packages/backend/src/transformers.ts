import {
	UserTransformer,
	defaultUserTransformer,
} from '@backstage/plugin-catalog-backend-module-github';

// This transformer will set the user's email to the first verified domain email in GitHub

export const myVerifiedUserTransformer: UserTransformer = async (user, ctx) => {
	const backstageUser = await defaultUserTransformer(user, ctx);
	if (backstageUser && user.organizationVerifiedDomainEmails?.length) {
		backstageUser.spec.profile!.email =
			user.organizationVerifiedDomainEmails[0];
	}
	return backstageUser;
};
