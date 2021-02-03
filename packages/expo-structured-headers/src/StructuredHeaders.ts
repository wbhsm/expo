import ExpoStructuredHeaders from './ExpoStructuredHeaders';
import { SampleOptions } from './StructuredHeaders.types';


export * from './StructuredHeaders.types';

/**
 * Great method that does a lot great stuff.
 * @param options specifies what great stuff you really want.
 *
 * @example
 * ```typescript
 * const result = await someGreatMethodAsync({ someOption: 'awesome' });
 * ```
 */
export async function someGreatMethodAsync(options: SampleOptions) {
  return await ExpoStructuredHeaders.someGreatMethodAsync(options);
}
